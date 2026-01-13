# frozen_string_literal: true

require "cgi"

module SocialHelper::TwitterMethods
  include MarkdownHelper

  def prepare_tweet(answer, post_tag = nil, omit_url = false)
    question_content = twitter_markdown(
      answer.question.content.gsub(/@(\w+)/, '\1')
    )
    answer_content = twitter_markdown(answer.content)

    original_question_length = question_content.length
    original_answer_length   = answer_content.length

    url = nil
    unless omit_url
      url = answer_url(
        id:       answer.id,
        username: answer.user.screen_name,
        host:     APP_CONFIG["hostname"],
        protocol: (APP_CONFIG["https"] ? :https : :http),
      )
    end

    # Initial caps (same limits as before)
    q_cap = question_content[0, 123]
    a_cap = answer_content[0, 124]

    q_needs_ellipsis = original_question_length > [123, question_content.length].min
    a_needs_ellipsis = original_answer_length   > [124, answer_content.length].min

    build_tweet = lambda do |q_len, a_len|
      q = q_cap[0, q_len]
      a = a_cap[0, a_len]

      q = "#{q}…" if q_needs_ellipsis && q_len > 0
      a = "#{a}…" if a_needs_ellipsis && a_len > 0

      [q, "—", a, post_tag, url].compact.join(" ")
    end

    valid_tweet = lambda do |text|
      Twitter::TwitterText::Validation.parse_tweet(text)[:valid]
    end

    # Fast path (already fits)
    q_len = q_cap.length
    a_len = a_cap.length
    tweet = build_tweet.call(q_len, a_len)
    return tweet if valid_tweet.call(tweet)

    # Binary search: trim question + answer together
    max_trim = [q_len, a_len].min
    low = 0
    high = max_trim

    while low < high
      mid = (low + high) / 2
      t = build_tweet.call(q_len - mid, a_len - mid)

      if valid_tweet.call(t)
        tweet = t
        high = mid
      else
        low = mid + 1
      end
    end

    # Fallback: trim answer only if still invalid
    unless valid_tweet.call(tweet)
      low = 0
      high = a_len

      while low < high
        mid = (low + high) / 2
        t = build_tweet.call(q_len, a_len - mid)

        if valid_tweet.call(t)
          tweet = t
          high = mid
        else
          low = mid + 1
        end
      end
    end

    tweet
  end

  def twitter_share_url(answer)
    "https://twitter.com/intent/tweet?text=#{CGI.escape(prepare_tweet(answer))}"
  end
end
