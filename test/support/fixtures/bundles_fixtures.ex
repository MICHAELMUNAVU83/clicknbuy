defmodule Clicknbuy.BundlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clicknbuy.Bundles` context.
  """

  @doc """
  Generate a bundle.
  """
  def bundle_fixture(attrs \\ %{}) do
    {:ok, bundle} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image: "some image",
        title: "some title"
      })
      |> Clicknbuy.Bundles.create_bundle()

    bundle
  end
end
