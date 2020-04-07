defmodule RegalocalWeb.PageControllerTest do
  use RegalocalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "RegaLocal"
  end
end
