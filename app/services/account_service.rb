class AccountService
  def increase_amount(resource, amount)
    resource.account.increment!(:amount, amount)
  end

  def decrease_amount(resource, amount)
    resource.account.decrement!(:amount, amount)
  end
end
