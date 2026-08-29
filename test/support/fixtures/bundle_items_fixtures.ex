defmodule Clicknbuy.BundleItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clicknbuy.BundleItems` context.
  """

  @doc """
  Generate a bundle_item.
  """
  def bundle_item_fixture(attrs \\ %{}) do
    {:ok, bundle_item} =
      attrs
      |> Enum.into(%{

      })
      |> Clicknbuy.BundleItems.create_bundle_item()

    bundle_item
  end
end
