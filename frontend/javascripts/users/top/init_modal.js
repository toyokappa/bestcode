export default class InitModal {
  constructor($root) {
    this.$root = $root
    this.displayModal();
  }

  displayModal() {
    this.$root.modal();
    $.ajax({
      url: '/users/top',
      method: 'PATCH',
    });
  }
}
