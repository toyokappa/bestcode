export default class EditComment {
  constructor($root) {
    this.$root = $root;
    this.bindEvents();
  }

  displayCommentField(e) {
    e.preventDefault();
    const $target = $(e.target);
    const $commentContainer = $target.closest(".comment-container");
    const commentId = $commentContainer.data().commentId;
    const commentBody = $commentContainer.data().commentBody;
    const $editCommentForm = $($(".ajax-comment-field").data().commentForm);

    $editCommentForm.find(".edit-comment-id").val(commentId);
    $editCommentForm.find(".edit-comment-body").val(commentBody);
    $commentContainer.find(".comment-body").hide();
    $commentContainer.find(".edit-comment").hide()
    $commentContainer.append($editCommentForm);
  }

  cancelComment(e) {
    e.preventDefault();
    const $target = $(e.target);
    const $commentContainer = $target.closest(".comment-container");

    $commentContainer.find(".edit-comment-form").remove()
    $commentContainer.find(".comment-body").show()
    $commentContainer.find(".edit-comment").show()
  }

  bindEvents() {
    this.$root.on("click", ".edit-comment", this.displayCommentField);
    this.$root.on("click", ".cancel-comment", this.cancelComment);
  }
}
