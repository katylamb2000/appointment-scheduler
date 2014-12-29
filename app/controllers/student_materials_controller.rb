class StudentMaterialsController < ApplicationController

  def update
    @student_material = StudentMaterial.find(params[:id])
    authorize! :update, @student_material
    if @student_material.update(student_material_params)
      flash[:notice] = "Your changes have been saved."
      redirect_to(request.referrer || student_dashboard_path )
    else
      flash[:failure] = "We're sorry, but something went wrong."
      redirect_to(request.referrer || student_dashboard_path )
    end
  end

  def student_material_params
    params.require(:student_material).permit(:student_notes)
  end

end