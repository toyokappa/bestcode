export default class InsertPullInfo {
  constructor($root) {
    console.log(0);
    this.$root = $root;
    this.bind();
  }

  async insertPullInfo(e) {
    const pullId = e.target.value;
    const path = "/users/pulls/info";
    const pull = await $.get(path, { id: pullId });
    const $reviewReqForm = $('.review-req-form');
    $reviewReqForm.find('.review-req-name').val(pull.name);
    $reviewReqForm.find('.review-req-description').val(pull.desc);
  }

  bind() {
    this.$root.on("change", ".pull-select", this.insertPullInfo);
  }
}
