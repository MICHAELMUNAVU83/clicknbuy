defmodule Clicknbuy.Repo.Migrations.RebrandSiteSettingsToClickNBuy do
  use Ecto.Migration

  def up do
    alter table(:site_settings) do
      modify :site_name, :string, default: "Click N Buy"
      modify :logo_url, :string, default: "/images/click-n-buy-logo.png"
    end

    execute """
    UPDATE site_settings
    SET site_name = 'Click N Buy'
    WHERE site_name IS NULL OR site_name = 'ClicknBuy'
    """

    execute """
    UPDATE site_settings
    SET logo_url = '/images/click-n-buy-logo.png'
    WHERE logo_url IS NULL OR logo_url = '' OR logo_url = '/images/clicknbuy-logo.png'
    """
  end

  def down do
    alter table(:site_settings) do
      modify :site_name, :string, default: "ClicknBuy"
      modify :logo_url, :string, default: nil
    end

    execute "UPDATE site_settings SET site_name = 'ClicknBuy' WHERE site_name = 'Click N Buy'"

    execute """
    UPDATE site_settings
    SET logo_url = NULL
    WHERE logo_url = '/images/click-n-buy-logo.png'
    """
  end
end
