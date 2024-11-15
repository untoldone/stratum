# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user != nil
  end

  def show?
    record.account.users.include?(user)
  end

  def create?
    user != nil
  end

  def new?
    create?
  end

  def update?
    record.account.users.include?(user)
  end

  def edit?
    update?
  end

  def destroy?
    record.account.users.include?(user)
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.joins(account: :users).where(account: { users: user })
    end

    private

    attr_reader :user, :scope
  end
end
