defmodule Clicknbuy.Repo.Migrations.CreateSiteSettings do
  use Ecto.Migration

  def change do
    create table(:site_settings) do
      add :site_name, :string, default: "ClicknBuy"
      add :site_tagline, :string, default: "Everyday Fashion, Effortlessly You"
      add :primary_color, :string, default: "#C8001F"
      add :font_heading, :string, default: "Playfair Display"
      add :font_body, :string, default: "Instrument Sans"
      add :font_script, :string, default: "Dancing Script"
      add :logo_url, :string
      add :instagram_url, :string
      add :whatsapp_number, :string
      add :support_email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
