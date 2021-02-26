defmodule RocketpayWeb.UsersViewTest do
  use Rocketpay.DataCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "John",
      password: "123secret",
      nickname: "Wick",
      email: "john@mail.com",
      age: 42
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id, balance: balance}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_reponse = %{
      message: "User created",
      user: %{
        account: %{balance: balance, id: account_id},
        id: user_id,
        name: "John",
        nickname: "Wick"
      }
    }

    assert response == expected_reponse
  end
end
