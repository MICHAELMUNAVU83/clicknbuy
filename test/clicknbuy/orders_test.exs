defmodule Clicknbuy.OrdersTest do
  use Clicknbuy.DataCase, async: true

  alias Clicknbuy.Orders
  alias Clicknbuy.Orders.Order
  alias Clicknbuy.Repo

  import Clicknbuy.CollectionsFixtures
  import Clicknbuy.ProductsFixtures
  import Clicknbuy.ProductVariantsFixtures

  describe "deduct_stock_for_order/1" do
    test "uses the first product variant when a quick-add item has no options" do
      product = product_with_collection_fixture()

      variant =
        product_variant_fixture(%{
          product_id: product.id,
          color_name: "Black",
          size: "Standard",
          stock_quantity: "10"
        })

      order = %Order{items: [%{"id" => product.id, "quantity" => 2}]}

      assert :ok = Orders.deduct_stock_for_order(order)
      assert Repo.reload!(variant).stock_quantity == "8"
    end

    test "deducts only the specifically selected variant" do
      product = product_with_collection_fixture()

      black =
        product_variant_fixture(%{
          product_id: product.id,
          color_name: "Black",
          size: "Standard",
          stock_quantity: "10"
        })

      white =
        product_variant_fixture(%{
          product_id: product.id,
          color_name: "White",
          size: "Standard",
          stock_quantity: "10"
        })

      order = %Order{
        items: [
          %{
            "id" => product.id,
            "color" => "White",
            "size" => "Standard",
            "quantity" => "3"
          }
        ]
      }

      assert :ok = Orders.deduct_stock_for_order(order)
      assert Repo.reload!(black).stock_quantity == "10"
      assert Repo.reload!(white).stock_quantity == "7"
    end
  end

  defp product_with_collection_fixture do
    collection = collection_fixture()

    product_fixture(%{
      collection_id: collection.id,
      image: "/images/test-product.jpg"
    })
  end
end
