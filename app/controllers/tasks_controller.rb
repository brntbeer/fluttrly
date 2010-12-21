class TasksController < ApplicationController
  def home
    redirect_to "/#{params[:name]}" if params[:name]

    @total_tasks = Task.count
    @total_lists = Task.select("DISTINCT(name)").count
  end
 
  def features
  end

  # GET /tasks
  # GET /tasks.xml
  def index

    @task = Task.new
    @tasks = Task.where("name = ?", params[:name]).order("created_at DESC")
    @count = 0

    @tasks.each do |t|
      @count += 1 unless t.completed
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks  }
      format.json { render :json => @tasks }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to("/#{params[:task][:name]}", :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task  }
        format.json { render :json => @task, :status => :created, :location => @task }
        format.js
      else
        format.html { render :action => "new", :errors => "Task cannot be blank" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity  }
        format.json { render :json => @task.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    
    @task.update_attribute(:completed, params[:completed])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity  }
        format.json { render :json => @task.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    params[:completed] = @task.completed
    name = @task.name
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
      format.json { head :ok }
      format.js
    end
  end

  # recieve a text, parse it and send it to update
  def sms
    puts params.inspect
    Rails.logger params.inspect
    redirect_to :index
  end
end
