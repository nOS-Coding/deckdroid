# Deployment Guide: GitHub Pages & Curl Installer

To host your TermuxDeck OS installer so it can be loaded via `curl`, follow these steps.

## 1. Prepare your GitHub Repository
Ensure your project is pushed to GitHub (e.g., `https://github.com/yourusername/termuxdeck`).

## 2. Enable GitHub Pages
1. Go to your repository on GitHub.
2. Navigate to **Settings** > **Pages**.
3. Under **Build and deployment** > **Source**, select **Deploy from a branch**.
4. Choose the `main` branch (or `master`) and the root `/` folder.
5. Click **Save**.

## 3. Custom Domain (Optional)
If you own `termuxdeck.dev`:
1. Add `termuxdeck.dev` to the **Custom domain** field in GitHub Pages settings.
2. Configure your DNS provider with an `A` record pointing to GitHub's IP addresses and a `CNAME` record for `www`.

## 4. How to use the Curl Installer
Once GitHub Pages is active, your `install.sh` file will be accessible at:
`https://yourusername.github.io/termuxdeck/install.sh`

Users can install it using:
```bash
curl -sL https://yourusername.github.io/termuxdeck/install.sh | bash
```

Or, if using your custom domain:
```bash
curl -sL https://termuxdeck.dev/install.sh | bash
```

## 5. Hosting the Apt Repository
The `scripts/build-repo.sh` script generates an `apt-repo/` directory. To make this functional:
1. Ensure the `apt-repo/` folder is pushed to the branch being served by GitHub Pages.
2. Update the `TDECK_REPO` variable in `install.sh` to match your GitHub Pages URL:
   `TDECK_REPO="https://yourusername.github.io/termuxdeck/apt-repo"`
