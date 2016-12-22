class TasksController < ApplicationController
  actions :index, :show, :create, :update, :start, :complete, :destroy
end
