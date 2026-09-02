defmodule Clicknbuy.Repo.Migrations.CreateSiteSettings do
  use Ecto.Migration

  def change do
    create table(:site_settings) do
      add :site_name, :string, default: "Click N Buy"
      add :site_tagline, :string, default: "Shop Smart, Buy Fast"
      add :primary_color, :string, default: "#2F32CE"
      add :font_heading, :string, default: "Poppins"
      add :font_body, :string, default: "DM Sans"
      add :font_script, :string, default: "Dancing Script"
      add :logo_url, :string, default: "/images/click-n-buy-logo.png"
      add :instagram_url, :string
      add :whatsapp_number, :string
      add :support_email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
