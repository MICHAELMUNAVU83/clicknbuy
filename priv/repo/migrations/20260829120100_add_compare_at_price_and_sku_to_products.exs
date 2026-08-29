defmodule Clicknbuy.Repo.Migrations.AddCompareAtPriceAndSkuToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      # Was-price shown struck through next to the sale price on product cards.
      add :compare_at_price, :integer
      # Stock-keeping unit surfaced on the product detail page.
      add :sku, :string
    end

    create unique_index(:products, [:sku])
  end
end
