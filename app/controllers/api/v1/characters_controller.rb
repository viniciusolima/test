module Api
  module V1
    class CharactersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :start_collect_data

      def index
        @characters = Character.all
        render :index, status: 201
      end

      def show
        @character = Character.find(params[:id])
        render :show, status: 201
      end

      def create
        @character = Character.new(character_params)
        if @character.save
          render :show, status: 201
        else
          render :fail, status: 422
        end
      end

      def update
         @character = Character.find(params[:id])
        if @character.update_attributes(character_params)
          render :show, status: 201
        else
          render :fail, status: 422
        end
      end

      def characters_elastic
        @characters = ::Characters::ElasticsearchResponseManager.new
        render :characters_elastic
      end

      def characters_elastic_full
        @characters = ::Characters::ElasticsearchResponseManager.new
        render :characters_elastic_full
      end

      private

      def character_params
        params.require(:character).permit(:id_marvel, :name, :image)
      end

      def start_collect_data
        PopulateWorker.perform_async()
      end
    end
  end
end
