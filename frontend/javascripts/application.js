import 'bootstrap';
import 'jquery-ujs';
import Select2 from 'select2';
import * as ActiveStorage from 'activestorage';
import '../stylesheets/application.sass';

import InitModal from './users/top/init_modal';
import PreviewImage from './util/preview_image';
import ToggleMarkdownPreview from './util/toggle_markdown_preview';
import InitChat from './users/rooms/init_chat';
import Flash from './util/flash'

document.addEventListener('DOMContentLoaded', () => {
  if($('.select2')[0]) $('.select2').select2();
  if($('.first-time-user')[0]) new InitModal($('.first-time-user'));
  if($('.preview-image')[0]) new PreviewImage($('.preview-image'));
  if($('.toggle-markdown-preview')[0]) new ToggleMarkdownPreview($('.toggle-markdown-preview'));
  if($('#chat-container')[0] && typeof gon !== 'undefined') new InitChat(gon);
  if($('.flash-container')[0]) new Flash($('.flash-container'));
});

$(window).on('resize', function() {
  if ($('#aside')[0] && window.innerWidth > 992) $('#aside').modal('hide');
});
