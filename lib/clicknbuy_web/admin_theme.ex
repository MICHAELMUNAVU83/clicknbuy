defmodule ClicknbuyWeb.AdminTheme do
  @moduledoc """
  Shared colour tokens for the admin area.

  The admin wears the same palette as the storefront (see `assets/css/app.css`):
  indigo `brand` is structural, red `accent` is the call-to-action, navy `ink`
  carries text, and `surface` is the page background.

  Order status is the one place several admin screens need to agree, so the
  classes live here rather than being re-declared per LiveView. The four
  pipeline stages read as an indigo ramp that darkens as an order progresses;
  the two terminal states sit outside the ramp — neutral slate for a cancelled
  order, accent red for a failed one — so they never look like another stage.
  Every chip pairs its dot with the status label, so colour is never the only
  thing carrying the meaning.
  """

  @pill %{
    "paid" => "bg-brand-50 text-brand-700",
    "processing" => "bg-brand-100 text-brand-700",
    "shipped" => "bg-brand-100 text-brand-800",
    "delivered" => "bg-ink-100 text-ink",
    "cancelled" => "bg-slate-100 text-slate-600",
    "failed" => "bg-accent-50 text-accent-700"
  }

  @pill_bordered %{
    "paid" => "bg-brand-50 text-brand-700 border-brand-200",
    "processing" => "bg-brand-100 text-brand-700 border-brand-300",
    "shipped" => "bg-brand-100 text-brand-800 border-brand-300",
    "delivered" => "bg-ink-100 text-ink border-ink-200",
    "cancelled" => "bg-slate-100 text-slate-600 border-slate-200",
    "failed" => "bg-accent-50 text-accent-700 border-accent-200"
  }

  @dot %{
    "paid" => "bg-[#9fa3fb]",
    "processing" => "bg-[#5558e6]",
    "shipped" => "bg-[#2427A5]",
    "delivered" => "bg-[#101340]",
    "cancelled" => "bg-slate-500",
    "failed" => "bg-accent"
  }

  @tile %{
    "paid" => {"bg-brand-50 border-brand-100", "text-brand-700"},
    "processing" => {"bg-brand-50 border-brand-200", "text-brand-700"},
    "shipped" => {"bg-brand-100 border-brand-200", "text-brand-800"},
    "delivered" => {"bg-ink-100 border-ink-200", "text-ink"},
    "cancelled" => {"bg-slate-100 border-slate-200", "text-slate-600"},
    "failed" => {"bg-accent-50 border-accent-100", "text-accent-700"}
  }

  # Avatar tints, drawn from the storefront palette so initials stay on-brand.
  @avatars ~w(
    bg-brand bg-ink bg-accent bg-brand-500
    bg-ink-600 bg-accent-600 bg-brand-700 bg-ink-500
  )

  @doc "Background + text classes for an order-status chip."
  def status_pill(status), do: Map.get(@pill, status, "bg-slate-100 text-slate-600")

  @doc "Chip classes including a matching border, for outlined chips."
  def status_pill_bordered(status),
    do: Map.get(@pill_bordered, status, "bg-slate-100 text-slate-600 border-slate-200")

  @doc "Background class for the small dot that precedes a status label."
  def status_dot(status), do: Map.get(@dot, status, "bg-slate-400")

  @doc "`{surface_classes, value_classes}` for a status summary tile."
  def status_tile(status),
    do: Map.get(@tile, status, {"bg-slate-100 border-slate-200", "text-slate-600"})

  @doc "Deterministic on-brand avatar tint for a customer or team member."
  def avatar_color(nil), do: "bg-brand"

  def avatar_color(seed) when is_binary(seed) do
    Enum.at(@avatars, rem(:erlang.phash2(seed), length(@avatars)))
  end

  def avatar_color(seed) when is_integer(seed) do
    Enum.at(@avatars, rem(seed, length(@avatars)))
  end
end
