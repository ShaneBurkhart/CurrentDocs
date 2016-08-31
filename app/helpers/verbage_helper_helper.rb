module VerbageHelperHelper
  def verbage_helper target_action
    case target_action
    when 'upload'
      'uploaded'
    when 'delete'
      'deleted'
    when 'update'
      'updated'
    else
      'changed'
    end
  end
end
