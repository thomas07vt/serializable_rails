require "spec_helper"

RSpec.describe SerializableRails::Serializable do
  class UserSerializer < SerializableRails::Serializer
    attributes :name, :email
  end

  class User
    include SerializableRails::Serializable

    def name
      "John"
    end

    def email
      "john@example.com"
    end
  end

  describe ".include" do
    it "automatically sets the related serializer" do
      expect(User.serializer).to eq(UserSerializer)
    end
  end

  describe ".serializer" do
    class AnotherSerializer < SerializableRails::Serializer
    end

    class Admin
      include SerializableRails::Serializable
      serializer AnotherSerializer
    end

    it "allow you to set the serializer directly" do
      expect(Admin.serializer).to eq(AnotherSerializer)
    end
  end

  describe "#as_json" do
    it "serializes using the correct Serializer" do
      expect(User.new.as_json).to eq({ "email" => "john@example.com", "name" => "John" })
    end
  end

  context "when a class is subclassed" do
    class Guest < User
      include SerializableRails::Serializable

      def name
        "Guest"
      end

      def email
        "guest@example.com"
      end
    end

    it "sets the parent serializer by default" do
      expect(User.serializer).to eq(UserSerializer)
    end
  end
end

