class MarkdownController < ApplicationController
  skip_before_action :authenticate_user

  def preview
    markdown = view_context.markdown(params[:body])
    render json: { body: markdown }
  end
end
