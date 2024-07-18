class Shop::Stripe::AccountsController < Shop::Stripe::StripeController
  #before_action :authenticate_user!

  # GET /shop/stripe/account_link
  def account_link
    account = nil
    if current_user.stripe_account_id.present?
      account = Stripe::Account.retrieve(current_user.stripe_account_id)
    else
      account = Stripe::Account.create
      current_user.update(stripe_account_id: account.id)
    end
    account_link = Stripe::AccountLink.create({
      account: account.id,
      return_url: shop_stripe_account_return_url, # wenn Onboarding abgeschlossen (e.g. /shop/stripe/return/acct_1PcRHGR95P7ff3vf")
      refresh_url: shop_stripe_account_refresh_url, # Lassen Sie die Aktualisierungs-URL einen neuen Onboarding-Kontolink erstellen und leiten Sie Ihre Nutzer/innen an diesen weiter
      type: "account_onboarding",
    })
    redirect_to account_link.url
  end

  # GET /shop/stripe/account_return
  def return
    account = Stripe::Account.retrieve(current_user.stripe_account_id)
    if is_ready?(account)
      current_user.update(stripe_account_is_ready: true)
      redirect_to edit_user_registration_path, notice: t('shop.flash.stripe_account_linked')
    else
      redirect_to edit_user_registration_path, alert: t('shop.flash.stripe_account_not_linkedy_yet')
    end
  end

  # GET /shop/stripe/account_refresh
  def refresh
    redirect_to shop_stripe_account_link_path
  end

private

  def is_ready?(account)
    (account.present? && account.charges_enabled && account.details_submitted && account.payouts_enabled)
  end

end
