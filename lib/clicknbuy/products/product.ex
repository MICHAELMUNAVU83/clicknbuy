defmodule Clicknbuy.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :position, :integer
    field :status, :string
    field :description, :string
    field :slug, :string
    field :image, :string
    field :base_price, :integer
    field :compare_at_price, :integer
    field :sku, :string
    field :badge_label, :string
    field :badge_color, :string
    field :is_featured, :boolean, default: false
    field :is_bestseller, :boolean, default: false
    field :is_new_arrival, :boolean, default: false
    field :size_advice, :string
    field :shipping_returns, :string
    belongs_to :collection, Clicknbuy.Collections.Collection

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :base_price,
      :compare_at_price,
      :sku,
      :badge_label,
      :image,
      :badge_color,
      :is_featured,
      :is_bestseller,
      :is_new_arrival,
      :position,
      :status,
      :collection_id,
      :size_advice,
      :shipping_returns
    ])
    |> validate_required([
      :name,
      :slug,
      :description,
      :image,
      :base_price,
      :is_featured,
      :is_bestseller,
      :is_new_arrival,
      :position,
      :status,
      :collection_id
    ])
    |> validate_number(:compare_at_price, greater_than: 0)
    |> validate_compare_at_above_base()
    |> unique_constraint(:sku)
  end

  # A struck-through "was" price only makes sense when it is above the live price.
  defp validate_compare_at_above_base(changeset) do
    base = get_field(changeset, :base_price)
    compare_at = get_field(changeset, :compare_at_price)

    if is_integer(base) and is_integer(compare_at) and compare_at <= base do
      add_error(changeset, :compare_at_price, "must be greater than the base price")
    else
      changeset
    end
  end
end
