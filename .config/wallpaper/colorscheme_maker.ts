import { oklch, formatHex } from "culori";

function seededRandom(daySeed: number): number {
    const x: number = Math.sin(daySeed) * 10000;
    return x - Math.floor(x);
}

function getDailyHueSeeded(): number {
    const now: Date = new Date();
    const startOfYear: Date = new Date(now.getFullYear(), 0, 1);
    const dayOfYear: number = Math.floor(
        (now.getTime() - startOfYear.getTime()) / (24 * 60 * 60 * 1000),
    );
    const randomValue: number = seededRandom(dayOfYear);
    return Math.floor(randomValue * 360);
}

const hueSeeded: number = getDailyHueSeeded();

// Create an OKLCH color object, then convert to hex
const color = {
    mode: "oklch",
    l: 0.65,
    c: 0.15,
    h: hueSeeded,
};

const hex = formatHex(color);
console.log(hex);
