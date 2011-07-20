RSpec::Matchers.define :respond_with do |expected_status|
  match do |last_response|
    @actual_status = last_response.status
    @expected_status = expected_status
    @actual_status == @expected_status
  end
  
  failure_message_for_should do
    "Expected #{@expected_status}, got: #{@actual_status}"
  end
  
  failure_message_for_should_not do
    "Did not expect #{@expected_status}, got: #{@actual_status}"
  end
end

RSpec::Matchers.define :respond_with_content_type do |expected_content_type|
  match do |last_response|
    response_content_type == expected_content_type
  end
  
  failure_message_for_should do
    "Expected #{@expected_content_type}, got: #{@actual_content_type}"
  end
  
  failure_message_for_should_not do
    "Did not expect #{@expected_content_type}, got: #{@actual_content_type}"
  end
  
  def response_content_type
    last_response.content_type.to_s
  end
end