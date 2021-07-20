module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: 'politician in Ghana',
    },
    claims: {
      P31: { value: 'Q5' }, // human
      P106: { value: 'Q82955' }, // politician
      P39: {
        value: 'Q107585189',
        references: {
          P854: 'https://www.parliament.gh/mps'
        },
      }
    }
  }
}
