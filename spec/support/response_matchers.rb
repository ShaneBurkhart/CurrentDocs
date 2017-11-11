# 401 requests are unauthenticated requests. A user isn't logged in.
RSpec::Matchers.define :be_authenticated do |expected|
  match { |actual| actual.status == 200 }
  match_when_negated { |actual| actual.status == 401 }

  failure_message do |actual|
    "expected response status #{actual.status} to be authenticated (200)"
  end

  failure_message_when_negated do |actual|
    "expected response status #{actual.status} not to be authenticated (401)"
  end
end

# 403 requests are unauthorized requests. A user is logged in, but can't access.
RSpec::Matchers.define :be_authorized do |expected|
  match { |actual| actual.status == 200 }
  match_when_negated { |actual| actual.status == 403 }

  failure_message do |actual|
    "expected response status #{actual.status} to be authorized (200)"
  end

  failure_message_when_negated do |actual|
    "expected response status #{actual.status} not to be authorized (403)"
  end
end
