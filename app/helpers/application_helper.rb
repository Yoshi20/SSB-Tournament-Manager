module ApplicationHelper

  def flash_class(level)
    case level.to_sym
      when :notice then "alert-info"
      when :success then "alert-success"
      when :error then "alert-danger"
      when :alert then "alert-warning"
    end
  end

  # # to keep the sort and order parameters
  # def table_params
  #   {
  #     sort: params[:sort],
  #     order: params[:order],
  #     order_by_letter: params[:order_by_letter],
  #     search: params[:search],
  #     limit: params[:limit],
  #   }
  # end

end
