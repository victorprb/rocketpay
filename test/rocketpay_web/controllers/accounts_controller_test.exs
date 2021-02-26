defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "John",
        password: "123secret",
        nickname: "Wick",
        email: "john@mail.com",
        age: 42
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      {:ok, conn: conn, account_id: account_id}
    end

    test "when params are valid, do the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => _message
             } = response
    end

    test "when there are invalid params, returns error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "invalid"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid value"}

      assert response == expected_response
    end
  end
end
