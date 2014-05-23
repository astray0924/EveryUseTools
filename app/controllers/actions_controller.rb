# encoding: utf-8
class ActionsController < ApplicationController
  def index
    @sort = params[:sort] ? params[:sort] : 'timeZ'
    @time_begin = params[:time_begin] ? DateTime.parse(params[:time_begin]) : DateTime.parse('2013-08-01 00:00:00')
    @time_end = params[:time_end] ? DateTime.parse(params[:time_end]) : DateTime.parse('2014-01-01 00:00:00')
    
    users = Hash.new
    for user in User.all
      users[user.id] = Hash.new
      users[user.id][:class] = :user
      users[user.id][:id] = user.email
    end
    
    cases = Hash.new
    for use_case in UseCase.all
      cases[use_case.id] = Hash.new
      cases[use_case.id][:class] = :use_case
      cases[use_case.id][:id] = use_case.id
      cases[use_case.id][:item] = use_case.item
      cases[use_case.id][:type] = use_case.purpose_type.sub('위해','to')
      cases[use_case.id][:purpose] = use_case.purpose
    end
   
    @actions = Array.new
    for use_case in UseCase.all
      if users[use_case.user_id] && cases[use_case.id]
        @actions << Hash.new
        @actions[-1][:time] = use_case.created_at
        @actions[-1][:user] = users[use_case.user_id]
        @actions[-1][:action] = "add"
        @actions[-1][:target] = "use_case"
        @actions[-1][:content] = cases[use_case.id]
        if use_case.updated_at - use_case.created_at > 1.hours
          @actions << Hash.new
          @actions[-1][:time] = use_case.updated_at
          @actions[-1][:user] = users[use_case.user_id]
          @actions[-1][:action] = "update"
          @actions[-1][:target] = "use_case"
          @actions[-1][:content] = cases[use_case.id]
        end
      end
    end
    for wow in Wow.all
      if users[wow.user_id] && cases[wow.use_case_id]
        @actions << Hash.new
        @actions[-1][:time] = wow.created_at
        @actions[-1][:user] = users[wow.user_id]
        @actions[-1][:action] = "add"
        @actions[-1][:target] = "wow"
        @actions[-1][:content] = cases[wow.use_case_id]
        if wow.updated_at - wow.created_at > 1.hours
          @actions << Hash.new
          @actions[-1][:time] = wow.updated_at
          @actions[-1][:user] = users[wow.user_id]
          @actions[-1][:action] = "update"
          @actions[-1][:target] = "wow"
          @actions[-1][:content] = cases[wow.use_case_id]
        end
      end
    end
    for metoo in Metoo.all
      if users[metoo.user_id] && cases[metoo.use_case_id]
        @actions << Hash.new
        @actions[-1][:time] = metoo.created_at
        @actions[-1][:user] = users[metoo.user_id]
        @actions[-1][:action] = "add"
        @actions[-1][:target] = "metoo"
        @actions[-1][:content] = cases[metoo.use_case_id]
        if metoo.updated_at - metoo.created_at > 1.hours
          @actions << Hash.new
          @actions[-1][:time] = metoo.updated_at
          @actions[-1][:user] = users[metoo.user_id]
          @actions[-1][:action] = "update"
          @actions[-1][:target] = "metoo"
          @actions[-1][:content] = cases[metoo.use_case_id]
        end
      end
    end
    for favorite in Favorite.all
      if users[favorite.user_id] && cases[favorite.use_case_id]
        @actions << Hash.new
        @actions[-1][:time] = favorite.created_at
        @actions[-1][:user] = users[favorite.user_id]
        @actions[-1][:action] = "add"
        @actions[-1][:target] = "favorite"
        @actions[-1][:content] = cases[favorite.use_case_id]
        if favorite.updated_at - favorite.created_at > 1.hours
          @actions << Hash.new
          @actions[-1][:time] = favorite.updated_at
          @actions[-1][:user] = users[favorite.user_id]
          @actions[-1][:action] = "update"
          @actions[-1][:target] = "favorite"
          @actions[-1][:content] = cases[favorite.use_case_id]
        end
      end
    end
    for relationship in Relationship.all
      if users[relationship.follower_id] && users[relationship.followed_id]
        @actions << Hash.new
        @actions[-1][:time] = relationship.created_at
        @actions[-1][:user] = users[relationship.follower_id]
        @actions[-1][:action] = "add"
        @actions[-1][:target] = "follow"
        @actions[-1][:content] = users[relationship.followed_id]
        if relationship.updated_at - relationship.created_at > 1.hours
          @actions << Hash.new
          @actions[-1][:time] = relationship.updated_at
          @actions[-1][:user] = users[relationship.follower_id]
          @actions[-1][:action] = "update"
          @actions[-1][:target] = "follow"
          @actions[-1][:content] = users[relationship.followed_id]
        end
      end
    end
    
    @actions = @actions.select do |action| @time_begin <= action[:time] && action[:time] <= @time_end end
    case @sort
    when 'timeZ'
      @actions = @actions.sort_by do |action| [Time.now-action[:time], action[:user][:id], action[:target]] end
    when 'timeA'
      @actions = @actions.sort_by do |action| [action[:time], action[:user][:id], action[:target]] end
    when 'user'
      @actions = @actions.sort_by do |action| [action[:user][:id], Time.now-action[:time], action[:target]] end
    when 'action'
      @actions = @actions.sort_by do |action| [action[:action], Time.now-action[:time], action[:user][:id], action[:target]] end
    when 'target'
      @actions = @actions.sort_by do |action| [action[:target], Time.now-action[:time], action[:user][:id]] end
    when 'user2'
      @actions = @actions.select do |action| action[:content][:class]==:user end
      @actions = @actions.sort_by do |action| [action[:content][:id], Time.now-action[:time], action[:user][:id], action[:target]] end
    when 'use_case'
      @actions = @actions.select do |action| action[:content][:class]==:use_case end
      @actions = @actions.sort_by do |action| [action[:content][:id], Time.now-action[:time], action[:user][:id], action[:target]] end
    end
  end
end
