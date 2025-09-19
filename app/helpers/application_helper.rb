module ApplicationHelper
  def link_to_modal(*, **kwargs, &)
    (kwargs[:data] ||= {})[:turbo_frame] = 'modal'
    link_to(*, **kwargs, &)
  end
end
