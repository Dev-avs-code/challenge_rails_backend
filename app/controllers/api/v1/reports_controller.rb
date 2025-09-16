module Api
  module V1
    class ReportsController < ApiApplicationController
      def maintenance_summary
        report = ReportParamsValidator.new(from: params[:from], to: params[:to])

        if report.invalid?
          return render json: {
            error: {
              code: 422,
              message: 'Validation failed',
              details: report.errors.to_hash
            }
          }, status: :unprocessable_entity
        else
          report = Reports::MaintenanceSummary.new(from: params[:from], to: params[:to]).call
        end

        render json: report, status: :ok
      end
    end
  end
end
