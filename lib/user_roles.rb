module UserRoles
  def owner?
    # We don't have shared users yet so any User is an owner.
    return self.is_a?(User)
  end

  def share_link?
    return self.is_a?(ShareLink)
  end
end
