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

      def login_admin
        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          @admin_user = Factory.create(:admin_user)
          sign_in @admin_user
        end

        after(:each) do
          @admin_user.destroy
        end

      end

end
