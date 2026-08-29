defmodule Clicknbuy.Repo.Migrations.AddAccentColorToSiteSettings do
  use Ecto.Migration

  def change do
    alter table(:site_settings) do
      add :accent_color, :string, default: "#DB4A44"
    end

    # Re-point existing rows at the new indigo/red storefront palette.
    execute(
      """
      UPDATE site_settings
      SET accent_color  = '#DB4A44',
          primary_color = '#2F32CE',
          font_heading  = 'Poppins',
          font_body     = 'DM Sans'
      """,
      """
      UPDATE site_settings
      SET primary_color = '#C8001F',
          font_heading  = 'Playfair Display',
          font_body     = 'Instrument Sans'
      """
    )
  end
end
