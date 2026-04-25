# Environment Setup Guide

Complete this before Session 1 to avoid spending exercise time on installation.

## Before You Start — Bootcamp Requirements

### 1. GitHub Account
You need a GitHub account to participate. If you don't have one, create one at https://github.com/signup (free).

### 2. Join the AI-Trailblazers Meetup Group
Join the AI-Trailblazers meetup group if you haven't already. This is how we coordinate sessions, share resources, and keep in touch after the bootcamp.

### 3. Claude Code Account
You need a Claude Code account (Claude Max or API access) to use Claude Code. If you don't have one yet, we'll provide access through the AI-Trailblazers meetup — we're subsidizing accounts for bootcamp participants. Reach out to the organizers if you need an account set up before Session 1.

### 4. Consent to Filming
This bootcamp will be filmed. By attending, you consent to being recorded. The recordings will be shared with the AI-Trailblazers community. If you have concerns, reach out to the organizers before the event.

---

## Environment Setup

### 1. Install Node.js (v18+)

**macOS:**
```bash
brew install node
```

**Windows:**
Download from https://nodejs.org/ (LTS version)

**Linux:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Verify: `node --version` (should show v18 or later)

### 2. Install Git

**macOS:** `brew install git` or install Xcode Command Line Tools
**Windows:** Download from https://git-scm.com/
**Linux:** `sudo apt-get install git`

Verify: `git --version`

### 3. Install Claude Code

**macOS/Linux:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Alternative methods:**
```bash
npm install -g @anthropic-ai/claude-code   # via npm
brew install claude-code                    # via Homebrew (macOS)
```

Verify: `claude --version`

### 4. Set Up Your LLM Provider

You need an LLM provider to use Claude Code. Choose ONE of the options below.

### Option A: Claude Code Max (Recommended)

The simplest option — a subscription plan that works automatically with Claude Code.

1. **Sign up for Claude Code Max** at https://claude.ai
2. **Log in** via `claude` in your terminal — it will detect your subscription automatically

No API key needed. No config files. Claude Code just works.

### Option B: ngrok AI Gateway

ngrok AI Gateway gives you one endpoint that routes to multiple LLM providers with automatic failover and cost optimization.

**Step-by-step:**

1. **Create an ngrok account** at https://dashboard.ngrok.com/signup
2. **Enable AI Gateway** in your dashboard under the "AI Gateway" section
3. **Create a gateway endpoint** — this gives you a URL like `https://your-gateway.ngrok.app`
4. **Add at least one upstream provider** (OpenAI, Anthropic, or Google) in the gateway settings
5. **Copy your API key** from the gateway dashboard

Your config file will look like:
```json
{
  "baseUrl": "https://your-gateway.ngrok.app/v1",
  "apiKey": "ngrok-ai-gw-your-key-here",
  "defaultModel": "ngrok/auto",
  "fallbackModel": "gpt-4o-mini"
}
```

**Verify your endpoint is secured:**
```bash
# This should succeed (authenticated request)
curl -s https://your-gateway.ngrok.app/v1/models \
  -H "Authorization: Bearer ngrok-ai-gw-your-key-here"

# This should fail with 401 (no auth = rejected)
curl -s https://your-gateway.ngrok.app/v1/models
```

If the second command returns data instead of an error, your endpoint is open — go back to the ngrok dashboard and make sure API key authentication is enabled.

**Security:** Your config file contains an API key. Add `config/` to your `.gitignore` so it doesn't get committed:
```bash
echo "config/" >> .gitignore
```

**Note:** ngrok AI Gateway is a separate product from ngrok tunnels. You specifically need the "AI Gateway" feature, not a regular tunnel.

### Option C: Direct OpenAI API

If you don't have ngrok AI Gateway, use OpenAI directly:

1. **Create an OpenAI account** at https://platform.openai.com/
2. **Generate an API key** at https://platform.openai.com/api-keys
3. **Add billing** — you'll need a few dollars of credit

Your config file will look like:
```json
{
  "baseUrl": "https://api.openai.com/v1",
  "apiKey": "sk-your-openai-key-here",
  "defaultModel": "gpt-4o",
  "fallbackModel": "gpt-4o-mini"
}
```

### Option D: Direct Anthropic API

1. **Create an Anthropic account** at https://console.anthropic.com/
2. **Generate an API key** at https://console.anthropic.com/settings/keys
3. **Add billing**

Your config file will look like:
```json
{
  "baseUrl": "https://api.anthropic.com/v1",
  "apiKey": "sk-ant-your-key-here",
  "defaultModel": "claude-sonnet-4-6",
  "fallbackModel": "claude-haiku-4-5"
}
```

### Which option should I choose?

| Option | Pros | Cons |
|--------|------|------|
| Claude Code Max | Zero config, no API keys, just works | Subscription plan |
| ngrok AI Gateway | Failover, cost routing, PII redaction, one key for all providers | Requires ngrok setup |
| Direct OpenAI | Common, pay per token | Single provider, no failover |
| Direct Anthropic | Native Claude models, pay per token | Single provider, no failover |

**All exercises work identically regardless of which option you choose.** The agent patterns are the same — only the provider setup differs.

### 5. Choose a Text Editor

VS Code is recommended: https://code.visualstudio.com/

Install the "Claude Code" extension for a better experience (optional).

## Troubleshooting

**"command not found: claude"**
- Make sure Node.js is v18+: `node --version`
- Try reinstalling: `curl -fsSL https://claude.ai/install.sh | bash`
- Or via npm: `npm install -g @anthropic-ai/claude-code`
- Check your PATH includes the install location

**"API key not found" or authentication errors**
- If using Claude Code Max: make sure you're logged in via `claude` — it detects your subscription
- If using an API key: `export ANTHROPIC_API_KEY=your-key`
- Or configure in Claude Code settings

**"Permission denied" on macOS**
- The curl installer doesn't require sudo
- If using npm: `sudo npm install -g @anthropic-ai/claude-code`
