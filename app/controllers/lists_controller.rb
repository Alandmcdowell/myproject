# encoding: UTF-8
class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  add_breadcrumb I18n.t('activerecord.models.list'), :lists_path
  def index
    @search = List.search(params[:q])
    @lists = @search.result(:distinct => true).paginate(:page => params[:page])
    respond_with(@lists)
  end

  def show
    add_breadcrumb @list.name, list_path(@list)
    respond_with(@list)
  end

  def new
    add_breadcrumb t('tooltips.new'), new_list_path
    @list = List.new
    respond_with(@list)
  end

  def edit
    add_breadcrumb @list.id, list_path(@list)
    add_breadcrumb t('tooltips.edit'), edit_list_path
  end

  def create
    @list = List.new(list_params)
    @list.save
    respond_with(@list)
  end

  def update
    @list.update(list_params)
    respond_with(@list)
  end

  def destroy
    @list.destroy
    respond_with(@list)
  end

  def move
    @current_list = @current_project.lists
    sort = Array.new
    params[:sort].each do |hash|
      sort << hash.to_i
    end
    @current_list.each_with_index do |list,index|
      list.sort = index*100
      list.save
    end

    $moved_list = params[:id]

    @current_list.each do |list|
      list.sort = (sort.index(list.id))+1
      list.save
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def set_list
    @list = @current_project.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :project, :sort)
  end
end
