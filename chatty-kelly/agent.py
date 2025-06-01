"""
chatty_kelly_agent.py – Christchurch news & weekend guide
Tested against google-adk 1.1.1 (May 29 2025)
"""

from __future__ import annotations
import datetime as _dt
import random
from zoneinfo import ZoneInfo
from typing import Dict, List

try:
    import feedparser  # optional live headlines
except ImportError:
    feedparser = None  # type: ignore

from google.adk.agents import Agent
from google.adk.runners import Runner        # needed only for voice streaming

CHCH_TZ = ZoneInfo("Pacific/Auckland")
RSS_FEEDS = [
    "https://www.stuff.co.nz/rss/national",  # Stuff national — filter later
    "https://www.rnz.co.nz/rss/national",
]


# ──────────────────────── tools ──────────────────────────
def get_chch_news() -> Dict[str, List[str] | str]:
    """
    Retrieve ≤ `limit` Christchurch-relevant headlines.

    Returns:
        status: "success" | "error"
        headlines: list[str]   # present on success
        error_message: str     # present on error
    """
    limit = 3
    if feedparser is None:
        demo = [
            "City council green-lights new riverside cycleway",
            "NZSO to play free concert in Hagley Park",
            "Canterbury Museum unveils pop-up atrium exhibit",
        ]
        return {"status": "success", "headlines": demo[:limit]}

    try:
        hits: List[str] = []
        for url in RSS_FEEDS:
            for e in feedparser.parse(url).entries:
                title = e.get("title", "")
                if any(k in title.lower() for k in ("christchurch", "canterbury")):
                    hits.append(title)
                if len(hits) >= limit:
                    break
            if len(hits) >= limit:
                break
        if not hits:
            raise ValueError("No Christchurch stories found")
        return {"status": "success", "headlines": hits[:limit]}
    except Exception as exc:
        return {"status": "error", "error_message": str(exc)}


def get_weekend_events() -> Dict[str, str | List[str]]:
    """
    List three fun things happening in Ōtautahi next weekend.

    Returns:
        status: "success"
        date:   str   # Saturday date, e.g. "07 Jun 2025"
        events: list[str]
    """
    events = [
        "🎪 Night Noodle Markets — North Hagley Park, Fri–Sun 4-10 pm",
        "🎨 Street-Art Walking Tour — meet Arts Centre Sat 11 am",
        "🏉 Crusaders vs Blues — Apollo Projects Stadium Sat 7 pm",
        "🎵 Jazz in the Botanic Gardens — Sun 2 pm by Peacock Fountain",
        "🛍️ Riccarton Farmers’ Market — Sun 9 am-2 pm",
    ]
    today = _dt.datetime.now(CHCH_TZ).date()
    days_to_sat = (5 - today.weekday()) % 7
    next_sat = today + _dt.timedelta(days=days_to_sat)
    return {
        "status": "success",
        "date": next_sat.strftime("%d %b %Y"),
        "events": random.sample(events, k=3),
    }


def tell_kiwi_joke() -> Dict[str, str]:
    """Return one classic Canterbury dad-joke."""
    jokes = [
        "Why did the tuatara ace maths? It always kept its *scale* in balance!",
        "What do you call an all-black beetle? A **rug-bug**!",
        "How do Kiwis start a race? ‘Ready, set, *chur*!’",
    ]
    return {"status": "success", "joke": random.choice(jokes)}


# ──────────────────── agent definition ───────────────────
root_agent = Agent(
    name="chatty_kelly",
    model="gemini-2.0-flash-live-001",
    description="Ōtautahi’s cheeky local news-whisperer",
    instruction=(
        "You are Chatty Kelly — upbeat, friendly, fond of bad puns. "
        "When a tool succeeds, draft a ≤120-word reply peppered with emojis, "
        "then sign off with ‘Cheers, Kelly from Chch!’ "
        "If a tool errors, apologise humorously."
    ),
    tools=[get_chch_news, get_weekend_events, tell_kiwi_joke],
)
