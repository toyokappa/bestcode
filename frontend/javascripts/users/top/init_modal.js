export default class InitModal {
  constructor($root) {
    this.$root = $root
    this.displayModal();
  }

  displayModal() {
    this.$root.modal();
    const token = $('meta[name="csrf_token"]').attr('content')

    $.ajax({
      url: '/users/top',
      method: 'PATCH',
      data: { authenticity_token: token }
    });
  }
}
