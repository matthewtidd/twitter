require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @auth_client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
        @client = Twitter::Client.new(:format => format)
      end

      describe ".enable_notifications" do

        before do
          stub_post("notifications/follow.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.enable_notifications("sferik")
            a_post("notifications/follow.#{format}").
              should have_been_made
          end

          it "should return the specified user when successful" do
            user = @auth_client.enable_notifications("sferik")
            user.name.should == "Erik Michaels-Ober"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.enable_notifications("sferik")
            end.should raise_error Twitter::Unauthorized
          end

        end

      end

      describe ".disable_notifications" do

        before do
          stub_post("notifications/leave.#{format}").
            to_return(:body => fixture("user.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        context "with authentication" do

          it "should get the correct resource" do
            @auth_client.disable_notifications("sferik")
            a_post("notifications/leave.#{format}").
              should have_been_made
          end

          it "should return the specified user when successful" do
            user = @auth_client.disable_notifications("sferik")
            user.name.should == "Erik Michaels-Ober"
          end

        end

        context "without authentication" do

          it "should raise Twitter::Unauthorized" do
            lambda do
              @client.disable_notifications("sferik")
            end.should raise_error Twitter::Unauthorized
          end

        end
      end
    end
  end
end
