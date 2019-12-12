class FactivityController < ApplicationController
  
  def new
    @factivity = Factivity.new
    @athletes = Athlete.all
  end

  def destroy
    @factivity = Factivity.find(params[:id])
    @factivity.destroy
    redirect_to data_factivity_data_path
  end
  
  def create
    @factivity = Factivity.new(factivity_params)

    if @factivity.save
      redirect_to @factivity
    else
      @athletes = Athlete.all
      render 'new'
    end

    def show
      @factivity = Factivity.find(params[:id])
    end
    
  end

  def remove_all
    Factivity.delete_all
    flash[:notice] = "All results deleted"
    redirect_to data_factivity_data_path
  end

  private

  def factivity_params
    params.require(:form).permit(:stdName,:activity,:exertion) 
  end
  
end
