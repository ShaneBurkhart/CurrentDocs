module UserRoles
  def user?
    return self.is_a?(User)
  end

  def share_link?
    return self.is_a?(ShareLink)
  end
end
