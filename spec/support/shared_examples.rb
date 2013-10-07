shared_examples "require_login" do
  it "redirects to the login page" do
    clear_current_user
    action
    response.should redirect_to login_path
  end
end

shared_examples "tokenable" do
  it "generates a random token when the user is created" do
    expect(object.token).to be_present
  end
end