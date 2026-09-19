defmodule Clicknbuy.Repo.Migrations.ApplyClickAndBuyLogoBrand do
  use Ecto.Migration

  def up do
    alter table(:site_settings) do
      modify :primary_color, :string, default: "#8A37F1"
      modify :accent_color, :string, default: "#7B1CEF"
      modify :logo_url, :string, default: "/images/PHOTO-2026-09-18-20-26-06.jpg"
      modify :support_email, :string, default: "info@clicknbuy.shop"
    end

    execute("""
    UPDATE site_settings
    SET primary_color = '#8A37F1',
        accent_color = '#7B1CEF',
        logo_url = '/images/PHOTO-2026-09-18-20-26-06.jpg',
        support_email = 'info@clicknbuy.shop',
        updated_at = CURRENT_TIMESTAMP
    """)
  end

  def down do
    alter table(:site_settings) do
      modify :primary_color, :string, default: "#2F32CE"
      modify :accent_color, :string, default: "#DB4A44"
      modify :logo_url, :string, default: "/images/click-n-buy-logo.png"
      modify :support_email, :string, default: nil
    end

    execute("""
    UPDATE site_settings
    SET primary_color = '#2F32CE',
        accent_color = '#DB4A44',
        logo_url = '/images/click-n-buy-logo.png',
        support_email = NULL,
        updated_at = CURRENT_TIMESTAMP
    """)
  end
end
