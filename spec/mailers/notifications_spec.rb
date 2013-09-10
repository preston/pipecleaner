require "spec_helper"

describe Notifications do
  describe "status_change" do
    let(:mail) { Notifications.status_change }

    it "renders the headers" do
      mail.subject.should eq("Status change")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
