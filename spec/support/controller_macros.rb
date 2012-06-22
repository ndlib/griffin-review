module ControllerMacros

      def login_user
        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          @user = Factory.create(:user)
          sign_in @user
        end

        after(:each) do
          @user.destroy
        end
      end

end
