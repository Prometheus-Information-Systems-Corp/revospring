import { Application } from "@hotwired/stimulus";
import AnnouncementController from "retrospring/controllers/announcement_controller";
import AutofocusController from "retrospring/controllers/autofocus_controller";
import CharacterCountController from "retrospring/controllers/character_count_controller";
import CharacterCountWarningController from "retrospring/controllers/character_count_warning_controller";

/**
 * This module sets up Stimulus and our controllers
 *
 * TODO: Temporary solution until I implement stimulus-rails and move
 *       controllers to app/javascript/controllers where an automated
 *       index can be generated
 */
export default function (): void {
  window['Stimulus'] = Application.start();
  window['Stimulus'].register('announcement', AnnouncementController);
  window['Stimulus'].register('autofocus', AutofocusController);
  window['Stimulus'].register('character-count', CharacterCountController);
  window['Stimulus'].register('character-count-warning', CharacterCountWarningController);
}
