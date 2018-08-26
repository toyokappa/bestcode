export default class ToggleMarkdownPreview {
  constructor($root) {
    this.$root = $root;
    this.beforeBody = '';
    this.bind();
  }

  showMarkdownEdit(e) {
    e.preventDefault();
    const $editBtn = $(e.target);
    const $root = $editBtn.closest('.toggle-markdown-preview');
    const $editField = $root.find('.markdown-edit-field');
    const $previewBtn = $root.find('.markdown-preview-btn');
    const $previewField = $root.find('.markdown-preview-field');

    $editBtn.addClass('active');
    $editField.show();
    $previewBtn.removeClass('active')
    $previewField.hide();
  }

  showMarkdownPreview(e) {
    e.preventDefault();
    const $previewBtn = $(e.target);
    const $root = $previewBtn.closest('.toggle-markdown-preview');
    const $previewField = $root.find('.markdown-preview-field');
    const $editBtn = $root.find('.markdown-edit-btn');
    const $editField = $root.find('.markdown-edit-field');

    $previewBtn.addClass('active');
    $previewField.show();
    $editBtn.removeClass('active');
    $editField.hide();
  }

  async fetchMarkdownPreview(e) {
    const $root = $(e.target).closest('.toggle-markdown-preview');
    const previewBody = $root.find('.preview-body').val();
    if (previewBody === this.beforeBody) return;

    this.beforeBody = previewBody;
    const token = $('meta[name="csrf_token"]').attr('content');
    const path = '/markdown/preview';
    const params = { body: previewBody, authenticity_token: token };
    const markdown = await $.post(path, params);
    $root.find('.markdown-body').html(markdown["body"]);
  }

  bind() {
    this.$root.on('click', '.markdown-edit-btn', this.showMarkdownEdit);
    this.$root.on('click', '.markdown-preview-btn', this.showMarkdownPreview);
    this.$root.on('mouseover', '.markdown-preview-btn', this.fetchMarkdownPreview);
  }
}
