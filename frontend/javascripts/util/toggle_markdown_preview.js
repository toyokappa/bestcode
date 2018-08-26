export default class ToggleMarkdownPreview {
  constructor($root) {
    this.$root = $root;
    this.beforeBody = '';
    this.bind();
  }

  showMarkdownEdit(e) {
    e.preventDefault();
    const $editBtn = $(e.target);
    const $container = $editBtn.closest('.markdown-preview-container');
    const $editField = $container.find('.markdown-edit-field');
    const $previewBtn = $container.find('.markdown-preview-btn');
    const $previewField = $container.find('.markdown-preview-field');

    $editBtn.addClass('active');
    $editField.show();
    $previewBtn.removeClass('active')
    $previewField.hide();
  }

  showMarkdownPreview(e) {
    e.preventDefault();
    const $previewBtn = $(e.target);
    const $container = $previewBtn.closest('.markdown-preview-container');
    const $previewField = $container.find('.markdown-preview-field');
    const $editBtn = $container.find('.markdown-edit-btn');
    const $editField = $container.find('.markdown-edit-field');

    $previewBtn.addClass('active');
    $previewField.show();
    $editBtn.removeClass('active');
    $editField.hide();
  }

  async fetchMarkdownPreview(e) {
    const $container = $(e.target).closest('.markdown-preview-container');
    const previewBody = $container.find('.preview-body').val();
    if (previewBody === this.beforeBody) return;

    this.beforeBody = previewBody;
    const token = $('meta[name="csrf_token"]').attr('content');
    const path = '/markdown/preview';
    const params = { body: previewBody, authenticity_token: token };
    const markdown = await $.post(path, params);
    $container.find('.markdown-body').html(markdown["body"]);
  }

  bind() {
    this.$root.on('click', '.markdown-edit-btn', this.showMarkdownEdit);
    this.$root.on('click', '.markdown-preview-btn', this.showMarkdownPreview);
    this.$root.on('mouseover', '.markdown-preview-btn', this.fetchMarkdownPreview);
  }
}
