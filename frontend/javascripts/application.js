import 'bootstrap';
import 'jquery-ujs';
import Select2 from 'select2';
import * as ActiveStorage from "activestorage";
import '../stylesheets/application.sass';

import EditComment from './users/rooms/review_comments/edit_comment';
import InitModal from './users/top/init_modal';

document.addEventListener("DOMContentLoaded", () => {
  if($(".select2")[0]) { $(".select2").select2(); }
  if($(".ajax-comment-field")[0]) { new EditComment($(".ajax-comment-field")); }
  if($(".first-time-user")[0]) { new InitModal($(".first-time-user")); }
});
