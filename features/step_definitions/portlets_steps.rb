# Steps for portlet.features
When /^I delete that portlet$/ do
  # cms_portlet_path(@subject) seemed to create a wrong path: /cms/portlets.1 rather than the below statement
  page.driver.delete "/cms/portlets/#{@subject.id}"
end

# Why oh why does path lookup with engines not work (i.e. want to say portlet_path(@subject))
When /^I view that portlet$/ do
  visit "/cms/portlets/#{@subject.id}"
end

When /^I edit that portlet$/ do
  visit "/cms/portlets/#{@subject.id}/edit"
end

When /^I visit that page$/ do
  assert_not_nil @last_page, "Couldn't find @last_page to visit. Check the order on steps'"
  visit @last_page.path
end


Given /^a page with a portlet that raises a Not Found exception exists$/ do
  @last_page = create(:public_page)
  @raises_not_found = create(:portlet, :code => 'raise ActiveRecord::RecordNotFound', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_not_found)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that raises an Access Denied exception exists$/ do
  @last_page = create(:public_page)
  @raises_access_denied = create(:portlet, :code => 'raise Cms::Errors::AccessDenied', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_access_denied)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that display "([^"]*)" exists$/ do |view|
  @last_page = create(:public_page)
  portlet = create(:portlet, :template=>view)
  @last_page.add_content(portlet)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that raises both a 404 and 403 error exists$/ do
  @last_page = create(:public_page)
  @raises_not_found = create(:portlet, :code => 'raise ActiveRecord::RecordNotFound', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_not_found)
  @raises_access_denied = create(:portlet, :code => 'raise Cms::Errors::AccessDenied', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_access_denied)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that raises both a 403 and any other error exists$/ do
  @last_page = create(:public_page)
  @raises_not_found = create(:portlet, :code => 'raise "A Generic Error"', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_not_found)
  @raises_access_denied = create(:portlet, :code => 'raise Cms::Errors::AccessDenied', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_access_denied)
  @last_page.publish!
  assert @last_page.published?
end